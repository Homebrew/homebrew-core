class Kerl < Formula
  desc "Easy building and installing of Erlang/OTP instances"
  homepage "https://github.com/kerl/kerl"
  url "https://github.com/kerl/kerl/archive/refs/tags/4.1.0.tar.gz"
  sha256 "5b754ba985f04125dc6824dbdab966f734615db6ec57cb544b4eff5d7f4c059d"
  license "MIT"
  head "https://github.com/kerl/kerl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c757158a932bce930b8be4a9d23a94cb076f609744cf5b55dfc23524f8bb02fc"
  end

  def install
    bin.install "kerl"
    bash_completion.install "bash_completion/kerl"
    zsh_completion.install "zsh_completion/_kerl"
  end

  test do
    system "#{bin}/kerl", "list", "releases"
  end
end
