class Blastem < Formula
  desc "Fast and accurate Genesis emulator"
  homepage "https://www.retrodev.com/blastem/"
  url "https://www.retrodev.com/repos/blastem/archive/v1.0.0.tar.gz"
  sha256 "ad35793e3e6d8f3a23914aecc2b28fe3aeb13ab9416d7d9ecbeba2781a755ceb"
  license "GPL-3.0-or-later"
  head "https://www.retrodev.com/repos/blastem", using: :hg

  livecheck do
    url "https://www.retrodev.com/repos/blastem/json-tags"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :json do |json, regex|
      json["tags"]&.map do |item|
        match = item["tag"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1d3be837a182c9c3794f99f8d05a56d9b664dff177a46012b43ae59210f3abac"
    sha256 cellar: :any, arm64_tahoe:       "3ada7ac311478d5f37fbccd77cd14c9c9eda18276e700b81592f81e09f43a72b"
    sha256 cellar: :any, arm64_sequoia:     "7fa084989f2845f425d2a29ae96ffb2e583a2b4bf7f971826af914312eeff0d8"
    sha256 cellar: :any, arm64_linux:       "501d1b152dee4f26e7bd3a7139dcbc553a1ea5af6bddde4562340351dd014597"
    sha256 cellar: :any, x86_64_linux:      "cbbb133a9566d6c825815d1cd85ae45c33b8bb16121ab303d72553536f2293a8"
  end

  depends_on "imagemagick" => :build
  depends_on "pillow" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "glew"
  depends_on "sdl2-compat"

  on_linux do
    depends_on "mesa"
    depends_on "zlib-ng-compat"
  end

  resource "vasm" do
    # phoenix.owl.de is the official upstream but no https url exist currently
    url "https://slackware.uk/sbosrcarch/by-name/development/vasm/vasm2_0f.tar.gz"
    mirror "http://phoenix.owl.de/tags/vasm2_0f.tar.gz"
    sha256 "c84b2de1cbb87831795fe64a85c5d9a7002a766e3a7c30b0a2d7d5e99d878f49"
  end

  def install
    resource("vasm").stage do
      system "make", "CPU=m68k", "SYNTAX=mot"
      (buildpath/"tool").install "vasmm68k_mot"
    end
    ENV.prepend_path "PATH", buildpath/"tool"

    system "make", "all", "menu.bin", "tmss.md", "HOST_ZLIB=1"
    libexec.install %w[blastem default.cfg gamecontrollerdb.txt images menu.bin rom.db shaders systems.cfg tmss.md]
    bin.write_exec_script libexec/"blastem"
  end

  test do
    assert_equal "blastem #{version}", shell_output("#{bin}/blastem -b 1 -v").chomp
  end
end
