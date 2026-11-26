class Libstatgrab < Formula
  desc "Provides cross-platform access to statistics about the system"
  homepage "https://libstatgrab.org/"
  url "https://github.com/libstatgrab/libstatgrab/releases/download/LIBSTATGRAB_0_92_2/libstatgrab-0.92.2.tar.gz"
  sha256 "ff559fcd4da75a4023af986c02c52ad51d4b68ae83fc0c8c461026126a8ebefa"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url :stable
    regex(/^LIBSTATGRAB[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    manifest_sha256 "65a23f9a0fee19b510722e1e7457745daa03d76f1a816a42ddf7e2c6a7740802"
    sha256 cellar: :any, arm64_golden_gate: "cd290d05291a4188886137d494013bfe00c3cdc012db5055d0fb9820a2305ef7"
    sha256 cellar: :any, arm64_tahoe:       "d8d91c63f0cd32e8babc1ab931772ee6b39c8abe877466654781605336b02503"
    sha256 cellar: :any, arm64_sequoia:     "0120622ba014ca9cc64eaf8147d78439eac57388ad2606fcb79d546d145a5ad5"
    sha256 cellar: :any, arm64_linux:       "8598dd9e92ce149beb38a1bc57ae377e55fe8fd62ec444a2594b95a4fe0e0ebb"
    sha256 cellar: :any, x86_64_linux:      "123a985b9646d2b9110fc3b75bbd120cf04eceb1cc01b5dce1975097948341cf"
  end

  deny_network_access!

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/statgrab general.os_name").chomp
    assert_equal "general.os_name = #{OS.kernel_name}", output
  end
end
