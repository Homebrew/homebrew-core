class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https://blog.kali-team.cn/projects/observer_ward/"
  url "https://github.com/emo-crab/observer_ward/archive/refs/tags/v2026.4.8.tar.gz"
  sha256 "18135c9f93023b09efa078bb0e354ad9a31a261afbbafba17dc90dbb1a06c525"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43f8bd966feefc910a8a110507aaa8a77ab5843fb499c27841a6ee2507aa48a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e4750a5685efe5e6fb17b607d862cf92daf81531e5b7f6d51dc877926b7319f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e47922e06279e9c0137fd86f3e2f0cbdddeb7ab029d3cf84087c43fd376f75a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "7adc3ee43dfdd1d82df1e2f33c585e30a96b3ed685d2f24182c880a86909cb51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e88c1ae6906692f06f062a0057e9005017b404da06f8b2da548163ad5d4ab5bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa5962a6daa911d399396387816d56fae4e41bce56196219482e777d42a55a14"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    rm ".cargo/config.toml" # disable `+crc-static`
    system "cargo", "install", *std_cargo_args(path: "observer_ward")
  end

  test do
    require "utils/linkage"

    system bin/"observer_ward", "-u"
    assert_match "0example", shell_output("#{bin}/observer_ward -t https://www.example.com/")
  end
end
