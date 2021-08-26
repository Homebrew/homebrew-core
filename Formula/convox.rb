class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.0.52.tar.gz"
  sha256 "961f3a127625341183a070d91ee35840f0f6ea284d2d32534328bd9d965ff0b0"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e503ebe52f677066e01a9e4180f93aafacfc1d326bc82cb1f4cd578b8f5f6d59"
    sha256 cellar: :any_skip_relocation, big_sur:       "f9f44fe49ec1864dcd72abb2b0932b75d960c5120e96c93c11df2a24ff6e661d"
    sha256 cellar: :any_skip_relocation, catalina:      "08dffd8d6ca1788812913d032630029f0ac87ba116272ae852261e14c6496a65"
    sha256 cellar: :any_skip_relocation, mojave:        "d65b92e8f228af2b1bd4da1500144a5086eead5ccf91e1b59b53de0b8f86d74e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c1b7d447f4a7d644fc916ac99b16e355bbd3f79b47e72b2b5265b5bbc2b8b22"
  end

  depends_on "go" => :build

  # Support go 1.17, remove when upstream patch is merged/released
  # https://github.com/convox/convox/pull/389
  patch do
    url "https://github.com/convox/convox/commit/d28b01c5797cc8697820c890e469eb715b1d2e2e.patch?full_index=1"
    sha256 "a0f94053a5549bf676c13cea877a33b3680b6116d54918d1fcfb7f3d2941f58b"
  end

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
