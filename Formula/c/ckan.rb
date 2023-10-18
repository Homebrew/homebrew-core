class Ckan < Formula
  desc "Comprehensive Kerbal Archive Network"
  homepage "https://github.com/KSP-CKAN/CKAN/"
  url "https://github.com/KSP-CKAN/CKAN/releases/download/v1.33.2/ckan.exe"
  sha256 "1489ddc51c860e05e29cff195f4a3a2c426018d370f38b423f0e45755014dd32"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0aebfcde33833ff4a208f1f27749294fa9ee25e9a7b4d42a11e618dc58cf756e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0aebfcde33833ff4a208f1f27749294fa9ee25e9a7b4d42a11e618dc58cf756e"
    sha256 cellar: :any_skip_relocation, sonoma:         "0aebfcde33833ff4a208f1f27749294fa9ee25e9a7b4d42a11e618dc58cf756e"
    sha256 cellar: :any_skip_relocation, ventura:        "0aebfcde33833ff4a208f1f27749294fa9ee25e9a7b4d42a11e618dc58cf756e"
    sha256 cellar: :any_skip_relocation, monterey:       "0aebfcde33833ff4a208f1f27749294fa9ee25e9a7b4d42a11e618dc58cf756e"
    sha256 cellar: :any_skip_relocation, big_sur:        "0aebfcde33833ff4a208f1f27749294fa9ee25e9a7b4d42a11e618dc58cf756e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "620c44d093856fb7ac1c6ef26460bb87e62fa91eac9f6f5878eb90093b500215"
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
