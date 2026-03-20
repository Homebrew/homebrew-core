class Binkd < Formula
  desc "TCP/IP FTN Mailer"
  homepage "https://github.com/pgul/binkd"
  url "https://github.com/pgul/binkd/archive/refs/tags/binkd-1_0_4.tar.gz"
  sha256 "67cc5c254198005e6d7c5c98b1d161ad146615874df4839daa86735aa5e3fa1d"
  license "GPL-2.0-or-later"
  head "https://github.com/pgul/binkd.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:binkd[._-])?v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98ede139dd485567a090cc5cc53906f6307761c12fa3a045f1e0849e8ad99ca1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cebbe4af0138e31dc3dbcd9f345f58deecc65a35d5093f6ba3ac148bd3a938a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "092929f47b8414deb86f31cdad9b6b972b04e8c780780f94c331dc6b3a13c9a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed2d0b7abdfd578a93e0c513dfba8eeab4a1b4f078e2c99a42946bc4a7985ec4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3823ed397a9c36d9a3bedaa37a8a6691c41902de71a82528d31c31fa7fe7bb1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "982860ec2548583dda4b84be1f8efdfc18b34bc4bbc9b665f3d98ce280a6720f"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    cp Dir["mkfls/unix/*"].select { |f| File.file? f }, "."
    inreplace "binkd.conf", "/var/", "#{var}/" if build.stable?
    system "./configure", "--disable-silent-rules",
                          "--mandir=#{man}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system sbin/"binkd", "-v"
  end
end
