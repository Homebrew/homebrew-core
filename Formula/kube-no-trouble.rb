# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class KubeNoTrouble < Formula
  desc "Easily check your cluster for use of deprecated APIs"
  homepage "https://www.doit-intl.com"
  url "https://github.com/doitintl/kube-no-trouble/archive/refs/tags/0.4.0.tar.gz"
  sha256 "b9d63f41ae1b64b9dd161c1eaa3a0de4f35b5c0030793f491342d1c2058b042d"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-o", bin/"kubent", "cmd/kubent/main.go"
  end

  test do
    system bin/"kubent", "-h"
  end
end
