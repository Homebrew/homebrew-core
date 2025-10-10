class Cdebug < Formula
  desc "Swiss army knife of container debugging"
  homepage "https://github.com/iximiuz/cdebug"
  url "https://github.com/iximiuz/cdebug/archive/refs/tags/v0.0.18.tar.gz"
  sha256 "c28d6c079177aa8de850e2edcbd284ac08cd3f9d77aac851928e1cc85a77fbcb"
  license "Apache-2.0"
  head "https://github.com/iximiuz/cdebug.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "b4a235c72e6296441f3af201d4ba7a01dd0c4465e5515184dc05baff66986b41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3cea617c367a9f6d5e3266264ce47fac44590794eb7a61b877f29077056acce5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a99dd51424bd5ab2caf6c9cd72ccf714cc47a4de4074011d74f0d037602d8cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9905753cb70ea35ccc41d3b699b61d4d2c1048de56f0d0c2e73aaba4a678dd06"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0825f6e7d64ec4f997804b7df677dfed0614cbdf63e8894629956dbf7e07131"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8bbecf15e4a887884194ce9d3de0e054c2967cd6b3f6b6604ca7d2979b416f0"
    sha256 cellar: :any_skip_relocation, ventura:        "44591eccd5959f57814791f5f28b62ab873ecb32bc8cf95ecbe1acf1dfec2374"
    sha256 cellar: :any_skip_relocation, monterey:       "162efaee908ca5548c0b1cd599171b845a19283be9d7daa8c299c4d81d306ca9"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8b13d0364e917932705d8a3604ee37b1c7e4570322043fa0012d29138ed74dc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fb21211a688f48562c5aeb2aa0e58922af7e31ab33486722d2bb58514b64c17"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.commit=#{tap.user}
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"cdebug", "completion")
  end

  test do
    # need docker daemon during runtime
    expected = if OS.mac?
      "cdebug: Cannot connect to the Docker daemon"
    else
      "cdebug: Permission denied while trying to connect to the Docker daemon socket"
    end
    assert_match expected, shell_output("#{bin}/cdebug exec nginx 2>&1", 1)

    assert_match "cdebug version #{version}", shell_output("#{bin}/cdebug --version")
  end
end
