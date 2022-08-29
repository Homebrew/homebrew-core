class Kubesess < Formula
  desc "Manage multiple kubernetes cluster at the same time"
  homepage "https://rentarami.se/posts/2022-08-05-kube-context-2/"
  url "https://github.com/Ramilito/kubesess/archive/refs/tags/1.2.5.tar.gz"
  sha256 "1ce69422fc29bde69ac02a209eb7b27a447598c39a3870759aa4c83e553b2e52"
  license "MIT"

  depends_on "rust" => :build
  depends_on "kubernetes-cli" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "USAGE:", shell_output("#{bin}/kubesess -h 2>&1")
  end
end
