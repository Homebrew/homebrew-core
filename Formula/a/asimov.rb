class Asimov < Formula
  desc "Automatically exclude development dependencies from Time Machine backups"
  homepage "https://github.com/stevegrunwell/asimov"
  url "https://github.com/stevegrunwell/asimov/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "77a0ef09c86d9d6ff146547902c749c43bc054f331a12ecb9992db9673469fab"
  license "MIT"
  head "https://github.com/stevegrunwell/asimov.git", branch: "develop"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "acc00f632c9cf38cca02e619759b0239e00a3b3d1120b5b8f55066a1eb134322"
  end

  def install
    bin.install buildpath/"asimov"
  end

  # Asimov will run in the background on a daily basis
  service do
    run opt_bin/"asimov"
    run_type :interval
    require_root true
    interval 86400 # 24 hours = 60 * 60 * 24
  end

  test do
    assert_match "Finding dependency directories with corresponding definition files…",
                 shell_output(bin/"asimov")
  end
end
