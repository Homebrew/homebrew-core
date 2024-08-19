class Jr < Formula
  desc "CLI program that helps you to create quality random data for your applications"
  homepage "https://jrnd.io/"
  url "https://github.com/ugol/jr/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "be0b28a1c4a3de2807303d0e42e16d65e7d99793c3e753c8d47ac824338a5ae7"
  license "MIT"
  head "https://github.com/ugol/jr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c964d0bcec163858f770b5f58cb8cc29898a80377eb69ac6450581ad0e5fbb05"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd2756fd69377deddcbfc662512d6098c827d433571be7b72d4cce241ac99b79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a9902e1b089e43da1176ffba069b2ae492fbd74cc3e82ef8b3b9801c6ef85dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe2901bc3f74b41690998006f37f5ade928b5fcc57a492b9a6a1d7837e632956"
    sha256 cellar: :any_skip_relocation, ventura:        "55463b907f4d2d402285368d9e62750a775c27e1edb6b28ef3621efdd7546c16"
    sha256 cellar: :any_skip_relocation, monterey:       "9ba587e30764154cbe08ebef244eae3b9db27dec7a5867cc4eda7b4a52763e80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6cc82c2d8db910ab88bc4c3d6b9c409352d2863e883f6ddf2d47738d667fb1a"
  end

  depends_on "go" => :build

  def install
    ENV.deparallelize { system "make", "all" }
    libexec.install Dir["build/*"]
    pkgetc.install "config/jrconfig.json"
    pkgetc.install "templates"
    (bin/"jr").write_env_script libexec/"jr", JR_HOME: pkgetc
  end

  test do
    assert_match "net_device", shell_output("#{bin}/jr template list").strip
  end
end
