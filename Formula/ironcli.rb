class Ironcli < Formula
  desc "Go version of the Iron.io command-line tools"
  homepage "https://github.com/iron-io/ironcli"
  head "https://github.com/iron-io/ironcli.git"

  stable do
    url "https://github.com/iron-io/ironcli/archive/0.1.2.tar.gz"
    sha256 "ff4d8b87f3dec4af83e6a907b3a857e24ceb41fabd2baa4057aae496b12324e6"

    # fixes the version
    patch do
      url "https://github.com/iron-io/ironcli/commit/1fde89f1.patch"
      sha256 "d037582e62073ae56b751ef543361cc381334f747b4547c0ccdf93df0098dba5"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "e6c39cc1dddd6acd8ce735836bb103cea0e90ce14b49453a1bc95515ccd77229" => :el_capitan
    sha256 "9db4f01a3e5910906cdea17bc724a8839eb277e7ce26e4d8b739dbe0917a17c1" => :yosemite
    sha256 "e354874cfff38921a6ef25bcf911637318f89ccf8fd1f07074e55ff393152acf" => :mavericks
  end

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/iron-io/ironcli"
    dir.install Dir["*"]
    cd dir do
      system "glide", "install"
      system "go", "build", "-o", bin/"iron"
    end
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/iron --version").chomp
  end
end
