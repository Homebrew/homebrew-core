class Phoneinfoga < Formula
  desc "Information gathering framework for phone numbers"
  homepage "https://sundowndev.github.io/phoneinfoga/"
  url "https://github.com/sundowndev/phoneinfoga/archive/v2.10.2.tar.gz"
  sha256 "ba6898493c0ac77c178d8942df670cf001caf112d2546560206ea071d6e4dbde"
  license "GPL-3.0-only"
  head "https://github.com/sundowndev/phoneinfoga.git", branch: "master"

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
