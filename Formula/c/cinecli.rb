class Cinecli < Formula
  include Language::Python::Virtualenv

  desc "Browse, inspect, and launch movie torrents directly from your terminal"
  homepage "https://github.com/eyeblech/cinecli"
  url "https://files.pythonhosted.org/packages/df/c6/bc46bf8f30ce881a8822ce7b4ead93f9cfaee466852c78cab3f8931f5639/cinecli-0.1.2.tar.gz"
  sha256 "5e2e053a6b0f71070b8e7028dab69be47b8def42639b90f805f28da5a040a141"
  license "MIT"
  revision 7
  head "https://github.com/eyeblech/cinecli.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "4dbe5e2ec10f3a9cad733ae9a8b8684eda5c1849bd9f2317e7efeb4220ce96e0"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.15"

  pypi_packages exclude_packages: ["certifi"]

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/5a/8e/38aa427ed5402449e226975b649c5dc73ccadfefeb95e6aecb8f8ea4b6b6/annotated_doc-0.0.5.tar.gz"
    sha256 "c7e58ce09192557605d8bbd92836d7e1d520ac9580096042c0bfd197efacf1bb"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
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
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
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
    url "https://files.pythonhosted.org/packages/03/51/d33db42cc72ffd8c30777547b42d01f0cbf9d95a770457698d0174b3ed71/typer-0.27.3.tar.gz"
    sha256 "d0396f770a560ab1b0a8504e13b5f254b728cedb05c61cf0359e944e50ce8901"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  # TODO: Remove when a release includes https://github.com/eyeblech/cinecli/pull/7.
  patch :DATA

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"cinecli", shell_parameter_format: :typer)
  end

  test do
    assert_match "Missing argument", shell_output("#{bin}/cinecli search 2>&1", 2)

    (testpath/"test.py").write <<~PYTHON
      from urllib.parse import parse_qs, urlparse
      from cinecli.magnets import build_magnet, select_best_torrent

      info_hash = "0123456789abcdef0123456789abcdef01234567"
      params = parse_qs(urlparse(build_magnet(info_hash, "The Matrix 1080p")).query)
      assert params["xt"] == [f"urn:btih:{info_hash}"]
      assert params["dn"] == ["The Matrix 1080p"]
      assert params["tr"]

      torrents = [{"quality": "720p", "seeds": 100}, {"quality": "1080p", "seeds": 10}]
      assert select_best_torrent(torrents) == torrents[1]
    PYTHON
    system libexec/"bin/python", testpath/"test.py"
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
