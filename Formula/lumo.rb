class Lumo < Formula
  desc "Fast, cross-platform, standalone ClojureScript environment"
  homepage "https://github.com/anmonteiro/lumo"
  url "https://github.com/anmonteiro/lumo/archive/1.10.1.tar.gz"
  sha256 "16acbd5f74893af8a08c8132c0779294c5767ae23d13084db08240e0a0a1738c"
  head "https://github.com/anmonteiro/lumo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb1a8b2993ef19affca4ec4f1d59b3d2ae147febc4a7dd9b3cf8d028829d38ef" => :mojave
    sha256 "36f9ab9e14f544ecbc00685366c3050bebb598463f67d8b02cad5b5ef3c37c86" => :high_sierra
    sha256 "4d21d87d8aae13c45f8cc501ae8132fc9e041db8f8ea4df1109180e7824f2bc1" => :sierra
  end

  depends_on "boot-clj" => :build
  depends_on :java => ["1.8", :build]
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    ENV["BOOT_HOME"] = "#{buildpath}/.boot"
    ENV["BOOT_LOCAL_REPO"] = "#{buildpath}/.m2/repository"
    system "boot", "release-ci"
    bin.install "build/lumo"
  end

  test do
    assert_equal "0", shell_output("#{bin}/lumo -e '(- 1 1)'").chomp
  end
end
