class Nuget < Formula
  desc "Package manager for Microsoft development platform including .NET"
  homepage "https://www.nuget.org/"
  url "https://dist.nuget.org/win-x86-commandline/v6.10.0/nuget.exe"
  sha256 "bad75b985cef3b2e52fa6141b207db25bafa8724189a420400fcf2787248bf4e"
  license "MIT"

  livecheck do
    url "https://dist.nuget.org/tools.json"
    regex(%r{"url":\s*?"[^"]+/v?(\d+(?:\.\d+)+)/nuget\.exe",\s*?"stage":\s*?"ReleasedAndBlessed"}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "028d16c1e6a966c40305df27bbd30c90d74a7990f5ba1bd995033de3f7675713"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1f9e9acce768ba68e9dc2b971efac8f3b40dee6de99ff2a5e5fc4404785cd0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "277495434789c075649c1b944b8b37a1449a3807906e0ef449edae124f62a119"
    sha256 cellar: :any_skip_relocation, sonoma:         "000089af1d98a1f7e61cc1b1697eac59b135efd5c453270b82dca1bee02b4f9c"
    sha256 cellar: :any_skip_relocation, ventura:        "0e2deeec02d9e3d8665ac165b0f8d58d74e1f757eb6f34b30264975cc6378cac"
    sha256 cellar: :any_skip_relocation, monterey:       "a13797c224521de0175a4efe5f987077ce0fbdce06c0cf3ec0d93a6f9a7fb2be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fb2fcb76201095aedd9170a31f7efda2561a2c2e8e056abaa1dab10628eec98"
  end

  depends_on "mono"

  def install
    libexec.install "nuget.exe" => "nuget.exe"
    (bin/"nuget").write <<~EOS
      #!/bin/bash
      mono #{libexec}/nuget.exe "$@"
    EOS
  end

  test do
    assert_match "NuGet.Protocol.Core.v3", shell_output("#{bin}/nuget list packageid:NuGet.Protocol.Core.v3")
  end
end
