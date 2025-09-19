class Cocot < Formula
  desc "Code converter on tty"
  homepage "https://vmi.jp/software/cygwin/cocot.html"
  url "https://github.com/vmi/cocot/archive/refs/tags/cocot-1.2-20171118.tar.gz"
  sha256 "b718630ce3ddf79624d7dcb625fc5a17944cbff0b76574d321fb80c61bb91e4c"
  license "BSD-3-Clause"
  head "https://github.com/vmi/cocot.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "f6a142983575a21225d725208388e9952675f5b32b1e8b99b5cf26c32ab137a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e50202bee861bf0692cb72d1228e2ad10fa93cc047d61480b3e0c558c81746f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2f9cbd95ef6d76b5354943e896cd03342392a266eeffe2784499ce138ad1fd22"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efe840ebc69a0212b0563b64b05e44426624ee8ed3c0aa6ef8f8101d1ca7ea0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f91587cce3e6d8aee833b0eefcbc49b50d8851455e523390f9a8899f39cd50d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "835a54f7142add9b9a3ab35097a6821fc9c100568b54c2d7fa52c283fd5ca6af"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb231dd02c02f24677d3b8b5b74c451efdd11f8300f108abed6e85f467ce3b89"
    sha256 cellar: :any_skip_relocation, ventura:        "8c309ff7d2661f534506c63909107b699d469d782d659e86f765b9e2a28bd319"
    sha256 cellar: :any_skip_relocation, monterey:       "d01d5f49b3bc174be130e15d2fbe1a2515064c5eef1a6e402ab9d2957c181874"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b1f6c60de8b11f5c3a3c454f30f551d2faf251185cfefacba11adbf61c12aaa"
    sha256 cellar: :any_skip_relocation, catalina:       "c56c078fce103138a45bd1c715dc3854b9eddf207575fada0e736b866d4f46bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9a9115e39b97cc0ff0b0097a76904c4e2947ea30efc4904fd9a214efa9b59c7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2cd1dd3dbbe2f6474e43965f09859c3d9921a6b7e21507c2a2c70fe69335c01"
  end

  def install
    # Workaround for newer Clang
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    system "./configure", *std_configure_args
    system "make", "install"
  end
end
