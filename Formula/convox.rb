class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.0.44.tar.gz"
  sha256 "e453cbd5e734f23a4b327f702818a2274496d850cf03613cde00431fccb22166"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "20b996d907f1c49626c3b5562d7324ff400e857ac7ea9e1b76da05f73dd9b99d" => :big_sur
    sha256 "6669f173ecb619316e6471e53d7d394542c2dc9dc623df3b6e2743c04b18cc3f" => :catalina
    sha256 "f5d197813d4e78a16d535c99efad0b1ffc283eafecc69d346df63f3ab1ef5ce2" => :mojave
    sha256 "ede78636eb4d9502a5cf008b9005c0f9f4d513ab8ac0e32a17e4f531ed01df85" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.version=#{version}
    ].join(" ")

    system "go", "build", *std_go_args, "-mod=vendor", "-ldflags", ldflags, "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
