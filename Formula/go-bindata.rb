class GoBindata < Formula
  desc "Small utility that generates Go code from any file"
  homepage "https://github.com/kevinburke/go-bindata"
  url "https://github.com/kevinburke/go-bindata/archive/v3.23.0.tar.gz"
  sha256 "20b1f8efd275e981b0db87f7a0d2d010d73bea17b2a27d09104fa672801e3a89"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4cf3f5bb1a186979e53d3345bb710a7a74b441526c28da759b3843e3b4ee065"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "078a9ef13ee9d74f0f6221511b3f5f63996da3edff5c2c6ffd5a89caaf1d754b"
    sha256 cellar: :any_skip_relocation, monterey:       "9b65f61ecee8fcd3877254a2eedba85c2fcda6253649e4bc7d3455ce9f8777c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "698399da0e0a31071c2abc1978f515cee3bde036e5e4f69a74acad8d3436d4a5"
    sha256 cellar: :any_skip_relocation, catalina:       "63b7e640caa27a4500fddcc1c0c05cc1138cb9fd8b13005346a513dc75e56c77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f99582470b38a5c5348569aedcc67dd617a801f711166d181ebb92f02291a99"
  end

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/kevinburke").mkpath
    ln_s buildpath, buildpath/"src/github.com/kevinburke/go-bindata"
    system "go", "build", "-o", bin/"go-bindata", "./go-bindata"
  end

  test do
    (testpath/"data").write "hello world"
    system bin/"go-bindata", "-o", "data.go", "data"
    assert_predicate testpath/"data.go", :exist?
    assert_match '\xff\xff\x85\x11\x4a', (testpath/"data.go").read
  end
end
