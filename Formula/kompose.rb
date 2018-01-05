class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "http://kompose.io"
  url "https://github.com/kubernetes/kompose/archive/v1.7.0.tar.gz"
  sha256 "74c3e375e7daf296de035e2ed8abb0b73ae318490722d4ee5d0da178d52cddf7"

  bottle do
    cellar :any_skip_relocation
    sha256 "4fc5e999895db88e3fa11ed44354b175f4ef1b03f89c1adc761814911f633d37" => :high_sierra
    sha256 "de48dc52883d83046c92a75d39d719f966a3342b05e62c648d6c28ff61613b30" => :sierra
    sha256 "2c37af42ea1998597d93313a663635f7fd48dbc770a28ccf5b2eb99bb007016a" => :el_capitan
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
