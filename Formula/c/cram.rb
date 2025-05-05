class Cram < Formula
  include Language::Python::Virtualenv

  desc "Functional testing framework for command-line applications"
  homepage "https://bitheap.org/cram"
  url "https://bitheap.org/cram/cram-0.7.tar.gz"
  sha256 "7da7445af2ce15b90aad5ec4792f857cef5786d71f14377e9eb994d8b8337f2f"
  license "GPL-2.0-or-later"

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    test = testpath/"test.t"
    test.write <<~EOS
      Simple cram test
        $ echo "Hello World"
        Hello World
    EOS

    system bin/"cram", test
  end
end
