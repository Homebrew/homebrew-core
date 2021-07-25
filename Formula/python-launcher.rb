class PythonLauncher < Formula
  desc "Launch your Python interpreter the lazy/smart way"
  homepage "https://github.com/brettcannon/python-launcher"
  url "https://github.com/brettcannon/python-launcher/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "31e5a4e50e3db4506e8484db06f6503df1225f482b40a892ffb5131b4ec11a43"
  license "MIT"
  head "https://github.com/brettcannon/python-launcher.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "docs/man-page/py.1"
    fish_completion.install "completions/py.fish"
  end

  test do
    binary = testpath/"python3.6"
    binary.write("Fake Python 3.6 executable")
    with_env("PATH" => testpath) do
      assert_match("3.6 │ #{binary}", shell_output("#{bin}/py --list"))
    end
  end
end
