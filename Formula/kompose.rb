class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "https://kompose.io/"
  url "https://github.com/kubernetes/kompose/archive/v1.19.0.tar.gz"
  sha256 "6a61ee974281baa27b2217126dff528cc50264a157ede58c23015c9a0939d380"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf9d4d8962090d5b3ab9319b1d14462204c31586f9bcc1baaaf5cda236ca1e01" => :catalina
    sha256 "a37bac4a8f9a08defbeccd3b63da8d3609ba748feb12a18eccba453cbb556437" => :mojave
    sha256 "0020c27e9313a49a1d396c21d9b64731d6081eb718e0fcada1d69fe99a4f55ae" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/kubernetes"
    ln_s buildpath, buildpath/"src/github.com/kubernetes/kompose"
    system "make", "bin"
    bin.install "kompose"

    output = Utils.popen_read("#{bin}/kompose completion bash")
    (bash_completion/"kompose").write output

    output = Utils.popen_read("#{bin}/kompose completion zsh")
    (zsh_completion/"_kompose").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kompose version")
  end
end
