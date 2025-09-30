class Astroterm < Formula
  desc "Planetarium for your terminal"
  homepage "https://github.com/da-luce/astroterm"
  url "https://github.com/da-luce/astroterm/archive/refs/tags/v1.0.9.tar.gz"
  sha256 "d96d70c644b258ed0adc3a700e6af122659ecabf3eed60d7cfb6810b5068f3eb"
  license "MIT"
  head "https://github.com/da-luce/astroterm.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0d027e2cc1fd0a23430be34a88382d77c4506bae0b5984fe38294ffb53171cd0"
    sha256 cellar: :any,                 arm64_sequoia: "59afefcb5518a5ec3f606202f6f1e614ff7a7338afe4390857861b4a58b86a41"
    sha256 cellar: :any,                 arm64_sonoma:  "b725c146a47cf2516699c6ad7779dd248fdc863b9daf7c4339d415455f06090b"
    sha256 cellar: :any,                 arm64_ventura: "dd53a52e2c8386f5c6bf1f1cc8722c764b6c17b06c705ea69d3cab4546cd968a"
    sha256 cellar: :any,                 sonoma:        "fc4d03bd92fede80413930d6ccd1febd685cd21a600f278c07d81daa0f8532a4"
    sha256 cellar: :any,                 ventura:       "cd7e62dd0ad54dc212302677ebe6d74b5dfa820e1eba0edb545a43087b9c3862"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "115541270f06d3f93203a9b6fe97df62c96ff5656fb13b08157df6dc1cd74718"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "369a156968b1a56a54b48779ebce9f0832e36f8433a876f1cec3a1aae3cdb876"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "argtable3"

  uses_from_macos "vim" => :build # for xxd
  uses_from_macos "ncurses"

  resource "bsc5" do
    url "http://tdc-www.harvard.edu/catalogs/BSC5", using: :nounzip
    sha256 "e471d02eaf4eecb61c12f879a1cb6432ba9d7b68a9a8c5654a1eb42a0c8cc340"
  end

  def install
    resource("bsc5").stage do
      (buildpath/"data").install "BSC5"
      mv buildpath/"data/BSC5", buildpath/"data/bsc5" if OS.linux?
    end

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # astroterm is a TUI application
    assert_match version.to_s, shell_output("#{bin}/astroterm --version")
  end
end
