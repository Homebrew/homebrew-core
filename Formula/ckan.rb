class Ckan < Formula
  desc "Comprehensive Kerbal Archive Network"
  homepage "https://github.com/KSP-CKAN/CKAN/"
  url "https://github.com/KSP-CKAN/CKAN/releases/download/v1.32.0/ckan.exe"
  sha256 "703f12e54712e6d049a16d48131ae6b68627f24fcfed18c2440c7b0448405869"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "baa3fca56ff2fa9b9a0e50e06ae746731108be8770d16575a1af43f0a507eb6c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "baa3fca56ff2fa9b9a0e50e06ae746731108be8770d16575a1af43f0a507eb6c"
    sha256 cellar: :any_skip_relocation, ventura:        "baa3fca56ff2fa9b9a0e50e06ae746731108be8770d16575a1af43f0a507eb6c"
    sha256 cellar: :any_skip_relocation, monterey:       "baa3fca56ff2fa9b9a0e50e06ae746731108be8770d16575a1af43f0a507eb6c"
    sha256 cellar: :any_skip_relocation, big_sur:        "baa3fca56ff2fa9b9a0e50e06ae746731108be8770d16575a1af43f0a507eb6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b4484b936329c4a7c01b520336949b246a7beedfb8d6b0624ebeec6bd933564"
  end

  depends_on "mono"

  def install
    (libexec/"bin").install "ckan.exe"
    (bin/"ckan").write <<~EOS
      #!/bin/sh
      exec mono "#{libexec}/bin/ckan.exe" "$@"
    EOS
  end

  def caveats
    <<~EOS
      To use the CKAN GUI, install the ckan-app cask.
    EOS
  end

  test do
    system bin/"ckan", "version"
  end
end
