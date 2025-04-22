class Duf < Formula
  desc "Disk Usage/Free Utility - a better 'df' alternative"
  homepage "https://github.com/muesli/duf"
  url "https://github.com/muesli/duf/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "ebc3880540b25186ace220c09af859f867251f4ecaef435525a141d98d71a27a"
  license "MIT"
  head "https://github.com/muesli/duf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "643ad7ae4f361bb24fd34c0f0e0ece98bd541ac3be3fd78af2bc7648346318e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "44fd140c8e0bcc0e3620a3c1f6adf957e6c4e0cacf53862b5f6ae471eaf037cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0957499928211de66a44dded811cac647a0916746a8d43ea2c6847ab5a34e48d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecd8c737c799f637d764a08d6e6ca989987b8076ac128af8d3d69a98dba68002"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ecd8c737c799f637d764a08d6e6ca989987b8076ac128af8d3d69a98dba68002"
    sha256 cellar: :any_skip_relocation, sonoma:         "83e15019a34b896d4492264ef1af541d12d28f7b5a0e4c31a475c9f5bc10aeaa"
    sha256 cellar: :any_skip_relocation, ventura:        "76b64a57517e3b695a23f8e5c6460c905b1f0c0f56e7d4d7272381433ac74d1f"
    sha256 cellar: :any_skip_relocation, monterey:       "3c21e47dd0b481fd42a8da9acd9abdd838d4ef03ccd9936904cb63ed357cab47"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c21e47dd0b481fd42a8da9acd9abdd838d4ef03ccd9936904cb63ed357cab47"
    sha256 cellar: :any_skip_relocation, catalina:       "3c21e47dd0b481fd42a8da9acd9abdd838d4ef03ccd9936904cb63ed357cab47"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3af3789f8c739679f465333040dcff841e4eb3a21c3dbf7f4959533fbc18304d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4f4e300c50dd460d534e71edcdf436251a0e9f44457d35cdf02a46d61b446ec"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    require "json"

    devices = JSON.parse shell_output("#{bin}/duf --json")
    assert root = devices.find { |d| d["mount_point"] == "/" }
    assert_equal "local", root["device_type"]
  end
end
