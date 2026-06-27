class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.24.9.tar.gz"
  sha256 "c3a3977b4cd3431350a5a37018a6b7f3b03cb2551e0f077d57473441b8f9b064"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a79b99306da889cab4a76a80fa4bd410a955345c4f164167c3b0d1ec047f3ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d7a587ccf1c5150e5dab2b7a9e290725c052fd221c655d210db7451adcc5f07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df5a0b2dab18b1c46f281ce090016db40bfc95e1bf96707506c78397101ff19d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a6317fc0f3bd25935d785eeff571997292111898ca9573e0f5dceb49796111e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87566fb775ccade20b4e34bb622735b626ec0c2b2165fc173dc44c44f2acf7f6"
    sha256 cellar: :any,                 x86_64_linux:  "95ca97dbeecd50434a9cf85ce9d4f0604633c6628737da813230b79175ef3fbf"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "systemd" # for libudev
  end

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", "-mod=readonly", *std_go_args(ldflags:), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
