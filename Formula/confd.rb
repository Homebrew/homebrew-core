class Confd < Formula
  desc "Manage local application configuration files using templates"
  homepage "https://github.com/kelseyhightower/confd"
  url "https://github.com/kelseyhightower/confd/archive/v0.16.0.tar.gz"
  sha256 "4a6c4d87fab77aa9827370541024a365aa6b4c8c25a3a9cab52f95ba6b9a97ea"
  head "https://github.com/kelseyhightower/confd.git"

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
