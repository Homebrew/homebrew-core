class JvmMon < Formula
  desc "Console-based JVM monitoring"
  homepage "https://github.com/ajermakovics/jvm-mon"
  url "https://github.com/ajermakovics/jvm-mon/archive/refs/tags/1.3.tar.gz"
  sha256 "71f27098bc130525c837ce5821481d795be1b315464f327dbe9d828a221338dd"
  license "Apache-2.0"
  head "https://github.com/ajermakovics/jvm-mon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "043a2ae54a8892543d300f963d276da6c317bac4c57b7ff31039649b782371b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61c0f2de3ba96b85b364c0c6df8a11dfca3a61790a19b105f5579ffba96f8fb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "569d3b771bab87123faac0038aa194a79788b5f5b8a5e1b73974baf70daf30c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "45ed63d60bbb978e2a1916675d38f7240ce6ea0d69b3510b05b9d3bc1e86e6a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "1041bf832360e6d61b4a229e64d3db2ea3e210ce52c5de8285c3a53cd3783a9c"
    sha256 cellar: :any_skip_relocation, ventura:       "e5f8b80e136462bc508d6b3089048ecbeb0ef70ff38d9fabd20f23234a6b471a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f6fe2a99d138c77ad21c6774fac197ea841265eccb240cdc14dd25df6a740eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "102d1f23f51c01a4c4959f508ad1d6c6b012ddfbaac2f142710fd04b2bfbb371"
  end

  depends_on "go" => :build
  depends_on "openjdk" => :build

  def install
    cd "jvm-mon-go" do
      system "./make-agent.sh"
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jvm-mon -v 2>&1")

    require "pty"
    ENV["TERM"] = "xterm"
    PTY.spawn(bin/"jvm-mon") do |_r, w, _pid|
      sleep 1
      w.write "q"
    end
  end
end
