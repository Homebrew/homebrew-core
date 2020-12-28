class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.5.1.tar.gz"
  sha256 "e49bbd017f5d559756537d96c4322d86499c1d24eecceacb65f4ccafe26adbad"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c3d56daaa0b9bcf881f9c5fc4115286c49e3a1a3dc19003dd943f12356e32113" => :big_sur
    sha256 "f0700c30fe39132a12da92077fd0b58a5ffede03ec01b89deb632bf9098f3cf5" => :arm64_big_sur
    sha256 "ad36b64a09477534520ad394a1e2229b546c5cafd04370d4d98fcafb7fbddf8b" => :catalina
    sha256 "a7c381a6121357b3cc70e209465650fb12ce48fc362bd2b780b074d01490324a" => :mojave
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=0.0.0-dev", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Walking dry-run=true version=0.0.0-dev", output
  end
end
