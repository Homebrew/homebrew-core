class Aggregate6 < Formula
  include Language::Python::Virtualenv

  desc "IPv4 and IPv6 prefix aggregation tool"
  homepage "https://github.com/job/aggregate6"
  url "https://github.com/job/aggregate6/archive/1.0.11.tar.gz"
  sha256 "8b48e4e7cbe0177d9ffe00c093c980272903043e391f1a815b1ed1637d451ddf"
  head "https://github.com/job/aggregate6.git"

  depends_on :python3

  resource "py-radix" do
    url "https://files.pythonhosted.org/packages/bf/4e/47d9e7f4dfd0630662e19d2cc1b2f1d307ec52df11f4a66f6ed6f0cce138/py-radix-0.10.0.tar.gz"
    sha256 "b8dbd1344bb30c6a1097d4103203c7b117d92931620365985018de4bef5aede3"
  end

  def install
    virtualenv_install_with_resources
    man7.install "aggregate6.7"
  end

  test do
    test_input = <<~EOS
      2001:db8::/48
      2001:db8:1::/48
      10.0.0.0/19
      10.0.255.0/24
      10.1.0.0/24
      10.1.1.0/24
      10.1.2.0/24
      10.1.2.0/25
      10.1.2.128/25
      10.1.3.0/25
      2001:db8:2::/48
      2001:db8:2::/56
    EOS

    expected_output = <<~EOS
      10.0.0.0/19
      10.0.255.0/24
      10.1.0.0/23
      10.1.2.0/24
      10.1.3.0/25
      2001:db8::/47
      2001:db8:2::/48
    EOS

    assert_equal expected_output, pipe_output("#{bin}/aggregate6", test_input), "Test Failed"
  end
end
