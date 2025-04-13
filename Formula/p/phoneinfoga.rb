class Phoneinfoga < Formula
  desc "Information gathering framework for phone numbers"
  homepage "https://sundowndev.github.io/phoneinfoga/"
  url "https://github.com/sundowndev/phoneinfoga/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "adb3cf459d36c4372b5cab235506afcba24df175eca87bb36539126bb1dbf64e"
  license "GPL-3.0-only"
  head "https://github.com/sundowndev/phoneinfoga.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7753aee0c8aa77f686eff25f3c74b9f53d620dee4f7be890afc31bddb631c95d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d56737c84d3cbb5cf5e4545e77d5b5f2ddc9c589305b68bc929187381dfa0bff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f08a417535abb3f01a6515580727b1f903ab3da8b4245f9c9cc4653fba8ec124"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7d428e6d911e94cca96ba259e884d3019e699aa5d7579d84da3770e23f1bccd"
    sha256 cellar: :any_skip_relocation, sonoma:         "9069391e52de3863ee44302bde11312aff29cdc199e0a3c0db158a149ce5b423"
    sha256 cellar: :any_skip_relocation, ventura:        "9c8cac2d134f82943c99c898e346093a11f3ab6f318532733b9c72340fec41a4"
    sha256 cellar: :any_skip_relocation, monterey:       "cca610f2c321e702af581ee8f2dc0e8253428d6882700c4a54a6bd81697a6ebc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f916109ebc6121eed5ebc4c013f3d7bb0b5f132fc6748e6ebc8611969a942d6c"
  end

  depends_on "go" => :build
  depends_on "yarn" => :build
  depends_on "node"

  def install
    cd "web/client" do
      system "yarn", "install", "--immutable"
      system "yarn", "build"
    end

    ldflags = %W[
      -s -w
      -X github.com/sundowndev/phoneinfoga/v2/build.Version=v#{version}
      -X github.com/sundowndev/phoneinfoga/v2/build.Commit=brew
    ]

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match "PhoneInfoga v#{version}-brew", shell_output("#{bin}/phoneinfoga version")
    system bin/"phoneinfoga", "scanners"
    assert_match "given phone number is not valid", shell_output("#{bin}/phoneinfoga scan -n foobar 2>&1", 1)
  end
end
