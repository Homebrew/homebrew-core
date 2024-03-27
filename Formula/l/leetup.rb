class Leetup < Formula
  desc "Command-line tool to solve Leetcode problems"
  homepage "https://github.com/dragfire/leetup"
  url "https://github.com/dragfire/leetup/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "cc5bc54eadff45bec29eb056f8882dbf9bb506837273f17b7a609754eba418b1"
  license "MIT"
  head "https://github.com/dragfire/leetup.git", branch: "master"

  # This repository also contains tags with a trailing letter (e.g., `0.1.5-d`)
  # but it's unclear whether these are stable. If this situation clears up in
  # the future, we may need to modify this to use a regex that also captures
  # the trailing text (i.e., `/^v?(\d+(?:\.\d+)+(?:[._-][a-z])?)$/i`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3204a2ea4e75bc1ac3087cd31a6f702d617fa1d690811b2b994bbd9f976df94b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ab846d5ddcfd62b1142bce710a7bd5a5f64729e4a071a13dec57ab4a672d3e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed58702a3142e7b96ff722504e774e7b42d0cd06d3094cbaea397c5ad0114ac5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5dca556fdca6aee7ef500e05e49a69206fb64fd24202277928bf105e8a90f76"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a2e8f71366fb1ea145b89717e7c840eec4cbd4297533cd3a71fbf560b4984d7"
    sha256 cellar: :any_skip_relocation, ventura:        "b9ec283491c56bee0fd27ed0bb45091e7f643427f00bba1fce4acbcf9c82ccaa"
    sha256 cellar: :any_skip_relocation, monterey:       "2aaceca02f57d15984b8a9099af8eacaac8ae48f77984c5334fb1f7b92f299e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "c040fbc4186c4c3470a1b3366f45717fbcd69f124cdd382eddc427a721c57a72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9173c182240851ac7b9bc16aa6a27f3410164645aa613a46ecce9e31e0165bbc"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match <<~EOS, shell_output("#{bin}/leetup user --logout")
      User not logged in!
      User logged out!
    EOS

    assert_match version.to_s, shell_output("#{bin}/leetup --version")
  end
end
