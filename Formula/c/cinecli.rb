class Cinecli < Formula
  include Language::Python::Virtualenv

  desc "Browse, inspect, and launch movie torrents directly from your terminal"
  homepage "https://github.com/eyeblech/cinecli"
  url "https://files.pythonhosted.org/packages/df/c6/bc46bf8f30ce881a8822ce7b4ead93f9cfaee466852c78cab3f8931f5639/cinecli-0.1.2.tar.gz"
  sha256 "5e2e053a6b0f71070b8e7028dab69be47b8def42639b90f805f28da5a040a141"
  license "MIT"
  revision 4
  head "https://github.com/eyeblech/cinecli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e58a69302e7245035a636c5934e4f6a6f229c0828288bf7801b3a1a14e1d2e02"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: ["certifi"]

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/57/ba/046ceea27344560984e26a590f90bc7f4a75b06701f653222458922b558c/annotated_doc-0.0.4.tar.gz"
    sha256 "fbcda96e87e9c92ad167c2e53839e57503ecfda18804ea28102353485033faa4"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/7b/60/e3bec1881450851b087e301bedc3daa9377a4d45f1c26aa90b0b235e38aa/charset_normalizer-3.4.6.tar.gz"
    sha256 "1ae6b62897110aa7c79ea2f5dd38d1abca6db663687c0b1ad9aed6f6bae3d9d6"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
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
    url "https://files.pythonhosted.org/packages/34/64/8860370b167a9721e8956ae116825caff829224fbca0ca6e7bf8ddef8430/requests-2.33.0.tar.gz"
    sha256 "c7ebc5e8b0f21837386ad0e1c8fe8b829fa5f544d8df3b2253bff14ef29d7652"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/c6/f3b320c27991c46f43ee9d856302c70dc2d0fb2dba4842ff739d5f46b393/rich-14.3.3.tar.gz"
    sha256 "b8daa0b9e4eef54dd8cf7c86c03713f53241884e814f4e2f5fb342fe520f639b"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/f5/24/cb09efec5cc954f7f9b930bf8279447d24618bb6758d4f6adf2574c41780/typer-0.24.1.tar.gz"
    sha256 "e39b4732d65fbdcde189ae76cf7cd48aeae72919dea1fdfc16593be016256b45"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
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
