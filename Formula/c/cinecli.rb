class Cinecli < Formula
  include Language::Python::Virtualenv

  desc "Browse, inspect, and launch movie torrents directly from your terminal"
  homepage "https://github.com/eyeblech/cinecli"
  url "https://files.pythonhosted.org/packages/df/c6/bc46bf8f30ce881a8822ce7b4ead93f9cfaee466852c78cab3f8931f5639/cinecli-0.1.2.tar.gz"
  sha256 "5e2e053a6b0f71070b8e7028dab69be47b8def42639b90f805f28da5a040a141"
  license "MIT"
  revision 6
  head "https://github.com/eyeblech/cinecli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f849eb32cd59450eb7a6514be15fdddee21a13e3c9ade51b32f06ade153a6a79"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: ["certifi"]

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/57/ba/046ceea27344560984e26a590f90bc7f4a75b06701f653222458922b558c/annotated_doc-0.0.4.tar.gz"
    sha256 "fbcda96e87e9c92ad167c2e53839e57503ecfda18804ea28102353485033faa4"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/23/e4/796662cd90cf80e3a363c99db2b88e0e394b988a575f60a17e16440cd011/click-8.4.0.tar.gz"
    sha256 "638f1338fe1235c8f4e008e4a8a254fb5c5fbdcbb40ece3c9142ebb78e792973"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/82/77/7b3966d0b9d1d31a36ddf1746926a11dface89a83409bf1483f0237aa758/idna-3.15.tar.gz"
    sha256 "ca962446ea538f7092a95e057da437618e886f4d349216d2b1e294abfdb65fdc"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/e4/51/9aed62104cea109b820bbd6c14245af756112017d309da813ef107d42e7e/typer-0.25.1.tar.gz"
    sha256 "9616eb8853a09ffeabab1698952f33c6f29ffdbceb4eaeecf571880e8d7664cc"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  # Fix breaking change in yts.bz API: https://github.com/eyeblech/cinecli/pull/7
  patch :DATA

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"cinecli", shell_parameter_format: :typer)
  end

  test do
    output = shell_output("#{bin}/cinecli search matrix")
    assert_match "The Matrix", output
  end
end

__END__
diff --git a/cinecli/cli.py b/cinecli/cli.py
index 6245772..a7ffbdf 100644
--- a/cinecli/cli.py
+++ b/cinecli/cli.py
@@ -127,7 +127,6 @@ def interactive():
         console.print(
             f"[cyan][{idx}][/cyan] "
             f"{movie['title']} ({movie['year']}) "
-            f"⭐ {movie['rating']}"
         )

     movie_index = Prompt.ask(
diff --git a/cinecli/ui.py b/cinecli/ui.py
index 3439d3b..207b095 100644
--- a/cinecli/ui.py
+++ b/cinecli/ui.py
@@ -11,14 +11,12 @@ def show_movies(movies):
     table.add_column("ID", style="cyan", justify="right")
     table.add_column("Title", style="bold")
     table.add_column("Year", justify="center")
-    table.add_column("Rating", justify="center")

     for movie in movies:
         table.add_row(
             str(movie["id"]),
             movie["title"],
             str(movie["year"]),
-            str(movie["rating"]),
         )

     console.print(table)
@@ -34,8 +32,6 @@ def show_movie_details(movie):

     text = (
         f"[bold]{movie['title']} ({movie['year']})[/bold]\n\n"
-        f"⭐ Rating: {movie['rating']}\n"
-        f"⏱ Runtime: {movie['runtime']} min\n"
         f"🎭 Genres: {', '.join(movie.get('genres', []))}\n\n"
         f"{description}"
     )
