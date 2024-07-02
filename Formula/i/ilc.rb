class Ilc < Formula
  desc "Simplify creating command-line utilities"
  homepage "https://github.com/evilmarty/ilc"
  url "https://github.com/evilmarty/ilc/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "a99fc51f1f3bd084c493fe42260181416c728ecc7f7ef4abb45c9ebee19fc4c9"
  license "GPL-3.0-only"
  head "https://github.com/evilmarty/ilc.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.BuildDate=#{Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SZ")}
      -X main.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match "Version: #{version}", shell_output("#{bin}/ilc -version")
  end
end
