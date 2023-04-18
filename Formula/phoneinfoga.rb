class Phoneinfoga < Formula
  desc "Information gathering framework for phone numbers"
  homepage "https://sundowndev.github.io/phoneinfoga/"
  url "https://github.com/sundowndev/phoneinfoga/archive/v2.10.4.tar.gz"
  sha256 "4ff3ee5960b966fda00b344a692553b7660f7bb16cd717940e875746fd1b9256"
  license "GPL-3.0-only"
  head "https://github.com/sundowndev/phoneinfoga.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "409a65925a78768ac77a9d933fc3d72787960486a5cc4bcdae9c44e97893e0cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e77670d28b38c6ca9caa3fdcee6d0ab1e08b57ab28d6d6d57e1616fbba07d053"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ade10305168ce327d695660d32c459b20dab13efe9f9ad5213976c3d33903a4"
    sha256 cellar: :any_skip_relocation, ventura:        "586c5da58bf0087a8198aac44450c97a13db72dcbf485750cab33475a09cff47"
    sha256 cellar: :any_skip_relocation, monterey:       "bed71b8eb9997ddef8402570fd2f76c04578c89fd81e4f9a120ee1b39a3e84ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ca5592759cd8a163fd146c32e10071521215b99d734afdef0fa126a5761ec33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "549c8b4267f70906e3afc6ab77b5dc9fad32289d7bcc08381faf7a0bb4fd11df"
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

    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match "PhoneInfoga v#{version}-brew", shell_output("#{bin}/phoneinfoga version")
    system "#{bin}/phoneinfoga", "scanners"
    assert_match "given phone number is not valid", shell_output("#{bin}/phoneinfoga scan -n foobar 2>&1", 1)
  end
end
