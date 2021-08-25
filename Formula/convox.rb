class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.0.51.tar.gz"
  sha256 "89319374e839c164ecc4ab314397e0c08ce8f49fe48f6faf625bdaa0b73736c4"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0dadd2bc011f1b5a1a9333e4bb646078b0817de59819a264f90c3faa6b563389"
    sha256 cellar: :any_skip_relocation, big_sur:       "d422f5f2addbf0f1ae87e703ac39ecb325129a650182caaeacac2604efe3facf"
    sha256 cellar: :any_skip_relocation, catalina:      "60ead08f69f2224afc46b225f2eefad5455e1f12870467301734e35d85a26c87"
    sha256 cellar: :any_skip_relocation, mojave:        "b802e8c4c9d838279f8ff68c641afdfbb71e8d1795202263ae3da982fdd49ea6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7199ad6b9b05046bd236827ad142543cfb415bd12db2c9aa524656f0584f2b9f"
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
