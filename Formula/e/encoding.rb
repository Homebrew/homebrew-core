class Encoding < Formula
  include Language::Python::Virtualenv

  desc "Simple file encoding and decoding utility"
  homepage "https://github.com/cloudberrypitech/encoding"
  url "https://github.com/cloudberrypitech/encoding/archive/refs/tags/V2.0.0.tar.gz"
  sha256 "b12af785a86ea1ef6045d6e97aedd6a6b5989075cd5f8b033ab8c3670ef62088"
  license "MIT"

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources

    (bin/"encoding").write <<~EOS
      #!/bin/sh
      exec "#{libexec}/bin/python3.14" -m encoding.cli "$@"
    EOS

    chmod 0755, bin/"encoding"
  end

  test do
    input = testpath/"input.txt"
    encoded = testpath/"input.txt.b64"
    decoded = testpath/"decoded.txt"

    input.write "Homebrew encoding test\n"

    system bin/"encoding", "encode", input.to_s, "-o", encoded.to_s
    assert_path_exists encoded

    system bin/"encoding", "decode", encoded.to_s, "-o", decoded.to_s
    assert_path_exists decoded

    assert_equal input.read, decoded.read
  end
end
