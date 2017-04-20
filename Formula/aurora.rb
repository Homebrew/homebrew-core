require "language/go"

class Aurora < Formula
  desc "Beanstalkd queue server console"
  homepage "https://xuri.me/aurora"
  url "https://github.com/Luxurioust/aurora/archive/2.0.tar.gz"
  sha256 "b1c9bfbc41b1e94824c64634d36f11ca7dc928635456cf258bd21f099edb3e22"

  bottle do
    cellar :any_skip_relocation
    sha256 "b3818dbfb08b076da83da55b4a34ff7b7e44e9b0b6c4a30c86a0c453241da60a" => :sierra
    sha256 "98475705d9202a9634a1ec530acb6715b6e1c853ffec430da730e96e5b7bef7c" => :el_capitan
    sha256 "8a9886f3bf81184f237cba2e121926b99c2ad2af1c6f9ad9abba9617b54146c6" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
        :revision => "99064174e013895bbd9b025c31100bd1d9b590ca"
  end

  go_resource "github.com/rakyll/statik" do
    url "https://github.com/rakyll/statik.git",
        :revision => "e383bbf6b2ec1a2fb8492dfd152d945fb88919b6"
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"
    mkdir_p "src/github.com/Luxurioust"
    ln_s buildpath, "src/github.com/Luxurioust/aurora"
    system "go", "build", "-o", bin/"aurora"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aurora -v")
  end
end
