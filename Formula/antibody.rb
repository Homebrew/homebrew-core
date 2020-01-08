class Antibody < Formula
  desc "The fastest shell plugin manager"
  homepage "https://getantibody.github.io/"
  url "https://github.com/getantibody/antibody/archive/v4.2.0.tar.gz"
  sha256 "552d94e2a0e5b3b93f8659f0a9ed5bdae4622c46a2418ca2a40573862fc991dc"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9b622b8764b1baf843440a5cda15b48c8c4fe887df85b20f200c1f7cc6a8d20f" => :catalina
    sha256 "fe386d626091b2c5b218ea725d1352351ea5f2bbe2913e466a7ba42a3fdd0956" => :mojave
    sha256 "c0dbe5808586236f555b502e6ab02a9c2947d42d7006154d20a2e738670c1e6d" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath", "-o", bin/"antibody"
  end

  test do
    # See if antibody can install a bundle correctly
    system "#{bin}/antibody", "bundle", "rupa/z"
    assert_match("rupa/z", shell_output("#{bin}/antibody list"))
  end
end
