class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      :tag      => "1.2.2",
      :revision => "cd4a148f37dc386986d6a6d899778849e686beea"

  bottle do
    cellar :any_skip_relocation
    sha256 "b98ded5227ce0fedfbac7508eeb9fbcb7711871790040dfbd88d490033e10da2" => :mojave
    sha256 "b5d03fcb8a5e25165c6d1acb038f2cee8d697d7556e4ab67649ef215381c05db" => :high_sierra
    sha256 "3a685e1ce0073aa7054d3e674888837654e374a53385b7a5692e3ca4bec906d2" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["TAG"] = version.to_s
    ENV["ISTIO_VERSION"] = version.to_s

    srcpath = buildpath/"src/istio.io/istio"
    outpath = buildpath/"out/darwin_amd64/release"
    srcpath.install buildpath.children

    cd srcpath do
      system "make", "istioctl"
      prefix.install_metafiles
      bin.install outpath/"istioctl"
    end
  end

  test do
    assert_match "Retrieve policies and rules", shell_output("#{bin}/istioctl get -h")
  end
end
