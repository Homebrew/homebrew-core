class Confd < Formula
  desc "Manage local application configuration files using templates"
  homepage "https://github.com/kelseyhightower/confd"
  url "https://github.com/kelseyhightower/confd/archive/v0.16.0.tar.gz"
  sha256 "4a6c4d87fab77aa9827370541024a365aa6b4c8c25a3a9cab52f95ba6b9a97ea"
  license "MIT"
  head "https://github.com/kelseyhightower/confd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "34d59b3c47493cd00685c62997ac0385f52f90a5d99adb9ed5c98576c6c02452" => :catalina
    sha256 "6c83fe2e7e744917d241e8fd51d76b83838ac08dcab31c2663c7b2c7703140cc" => :mojave
    sha256 "8605d52c611da0530d31178fbb9805592113d70b3d496d21a34696ff499aac70" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/kelseyhightower/confd").install buildpath.children
    cd "src/github.com/kelseyhightower/confd" do
      system "go", "install", "github.com/kelseyhightower/confd"
      bin.install buildpath/"bin/confd"
    end
  end

  test do
    templatefile = testpath/"templates/test.tmpl"
    templatefile.write <<~EOS
      version = {{getv "/version"}}
    EOS

    conffile = testpath/"conf.d/conf.toml"
    conffile.write <<~EOS
      [template]
      prefix = "/"
      src = "test.tmpl"
      dest = "./test.conf"
      keys = [
          "/version"
      ]
    EOS

    keysfile = testpath/"keys.yaml"
    keysfile.write <<~EOS
      version: v1
    EOS

    system "confd", "-backend", "file", "-file", "keys.yaml", "-onetime", "-confdir=."
    assert_predicate testpath/"test.conf", :exist?
    refute_predicate (testpath/"test.conf").size, :zero?
  end
end
