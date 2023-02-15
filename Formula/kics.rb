class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v1.6.10.tar.gz"
  sha256 "0c9f652ef776eddd823c2f8ce33e6eeedad27dcb9a5ae62b3566785be9ad16a2"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c67e8c3c3eb35cd3288323956108dd580c3921668143fa90e9c266533d1d0893"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "829cdaa4c9087fdba5e3d36e261ab12f1f8e5a2cbd6a9ec0e41eefbbd99cc7bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a53d4b1cdb750e49b7c06f45a1f117a0fa23da96c08b2b5b1a4bf2f20c47926"
    sha256 cellar: :any_skip_relocation, ventura:        "ad9b4daf5a9a980b1bcf0b9f98211579aa58464da5fb2496baa4282bf6021aa5"
    sha256 cellar: :any_skip_relocation, monterey:       "d9bc6d7973e77dc0b372672de199d59f97857bb8d1f8fe43569936d4175a428e"
    sha256 cellar: :any_skip_relocation, big_sur:        "48bc294769ec7e4e2c4980e458a118a51639628a19647b74ffcf430d8da966b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aecaaf03b454bdab4a23dcdbf56377fb16a118f67797df768603216289952bdb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Checkmarx/kics/internal/constants.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/console"

    pkgshare.install "assets"
  end

  def caveats
    <<~EOS
      KICS queries are placed under #{opt_pkgshare}/assets/queries
      To use KICS default queries add KICS_QUERIES_PATH env to your ~/.zshrc or ~/.zprofile:
          "echo 'export KICS_QUERIES_PATH=#{opt_pkgshare}/assets/queries' >> ~/.zshrc"
      usage of CLI flag --queries-path takes precedence.
    EOS
  end

  test do
    ENV["KICS_QUERIES_PATH"] = pkgshare/"assets/queries"
    ENV["DISABLE_CRASH_REPORT"] = "0"

    assert_match "Files scanned: 0", shell_output("#{bin}/kics scan -p #{testpath}")
    assert_match version.to_s, shell_output("#{bin}/kics version")
  end
end
