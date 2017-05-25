class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "http://kompose.io"
  url "https://github.com/kubernetes-incubator/kompose/archive/v0.7.0.tar.gz"
  sha256 "6b649e91494e57ffd6c6f1d6150072d4c5589d75568172a8f3a0d6cbd7322599"

  bottle do
    cellar :any_skip_relocation
    sha256 "b58c7ce2d97bebece615026db04df5e25af1267b90522a01ec5b6dbb873c8193" => :sierra
    sha256 "476e70ab5ddbc77b0d2234d33e456cb46e4fb669db76b306dbdeb2350c3e1df1" => :el_capitan
    sha256 "6afabe89e409832e294cdc13f67b8e162c57d046564a0ab777330a889c96d9e2" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/kubernetes-incubator"
    ln_s buildpath, buildpath/"src/github.com/kubernetes-incubator/kompose"
    system "make", "bin"
    bin.install "kompose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kompose version")
  end
end
