class Pyyaml < Formula
  desc "YAML parser and emitter for Python"
  homepage "https://pyyaml.org/wiki/PyYAML"
  url "https://pyyaml.org/download/pyyaml/PyYAML-3.12.tar.gz"
  sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"

  depends_on "libyaml"
  depends_on :python if MacOS.version <= :snow_leopard

  def install
    system "python", *Language::Python.setup_install_args(prefix)
  end

  test do
    (testpath/"test.py").write <<~EOS
      #!/usr/bin/env python
      import os, sys, yaml.reader

      args = sys.argv

      try:
          stream = yaml.reader.Reader(args[1])
          while stream.peek() != u'\\0':
              stream.forward()
      except yaml.reader.ReaderError, exc:
            print exc
    EOS

    system "python", "test.py", test_fixtures("updater_fixture.yaml")
  end
end
