class Mp3wrap < Formula
  desc "Wrap two or more mp3 files in a single large file"
  homepage "https://mp3wrap.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mp3wrap/mp3wrap/mp3wrap%200.5/mp3wrap-0.5-src.tar.gz"
  sha256 "1b4644f6b7099dcab88b08521d59d6f730fa211b5faf1f88bd03bf61fedc04e7"
  license "LGPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/mp3wrap[._-]v?(\d+(?:\.\d+)+)(?:-src)?\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "28af69383fd4f657495f0aedda9e53ac66cccce24bda0a280ebf5a79939cce6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "881da7c1c1c1d3b667f6524d66c01de8d73e8a113b84763ea0d57395518c3523"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b5c9848d068d5f4f3758dc2629daea1ac755ce288b9663b302b13045bc9a1e0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2bf343f21cede8d098ddb1c389818e91d8aaa8363601b1c3f56d02b2152285f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a84d1acbd3aaa6432bf22d6052c1d8afa5b54145e1ecec0a16c6da05cf2df95"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ee84cc1015ba99900a71896d7055b3fcf305828dc6a8430da552b0fee18a01b"
    sha256 cellar: :any_skip_relocation, sonoma:         "73592a53432ef216313142884f12af2b40c2a62b86d4ed1539b3824d7c66f675"
    sha256 cellar: :any_skip_relocation, ventura:        "6f72f17884f6f657f8c8db28383b880d6fb4448181689997c9834d860d28b7bf"
    sha256 cellar: :any_skip_relocation, monterey:       "e07fa1bc62342d8166accae07efd264b0449ee57ed27224f05897444bbec43fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb2198208b5da896231a815235652c3342ed305a858950c9fb10bc7e296d1e34"
    sha256 cellar: :any_skip_relocation, catalina:       "fa93ce86b2a055521e166325b4219773f04c6886075bd77932dcb6dff436ddce"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "962b508b014f584bcb0ea88a84e150e6c0ebdb80573252a7ffca2c6bc25bb567"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e666ba56f6a93702e3a37b4dd6f8d908b6a16246ba9ad5467518c970f4ac30ab"
  end

  def install
    # Workaround for arm64 linux. Upstream isn't actively maintained
    ENV.append_to_cflags "-fsigned-char" if OS.linux? && Hardware::CPU.arm?

    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    source = test_fixtures("test.mp3")
    system bin/"mp3wrap", "#{testpath}/t.mp3", source, source
    assert_path_exists testpath/"t_MP3WRAP.mp3"
  end
end
