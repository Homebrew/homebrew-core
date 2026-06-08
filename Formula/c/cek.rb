class Cek < Formula
  desc "Explore the (overlay) filesystem and layers of OCI container images"
  homepage "https://github.com/bschaatsbergen/cek"
  url "https://github.com/bschaatsbergen/cek/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "df9c569279cccd4edd8d99fe334568ce141331dc4ab1aa77bffa3ae0d849bf94"
  license "MIT"
  head "https://github.com/bschaatsbergen/cek.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbdff3f7de472e4566a8b4d5b52d8dad6dab459f38adba09fe29958650738fec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbdff3f7de472e4566a8b4d5b52d8dad6dab459f38adba09fe29958650738fec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbdff3f7de472e4566a8b4d5b52d8dad6dab459f38adba09fe29958650738fec"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b70dbb71e41cfdc5c1850901a8fde575a3fc914f19936afca9399bab054474e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d99a71a392f0d75ab253671d04b5bbb033466a205c403f84b44cdf122ae5967"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb5a90842490b3753de41eaccb5cb00989aaf88b4d7545abaf53960c47cc4d7c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/bschaatsbergen/cek/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_includes shell_output("#{bin}/cek version"), "cek version #{version}"
    assert_match "localhost", shell_output("#{bin}/cek cat alpine:latest /etc/hostname")
  end
end
