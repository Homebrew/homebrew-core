class Ncsdk < Formula
  desc "Software Development Kit for the Neural Compute Stick"
  homepage "https://github.com/movidius/ncsdk"
  url "https://github.com/movidius/ncsdk/archive/v1.12.00.01.tar.gz"
  sha256 "aceca6ffa87c87c2b29f5a89ed97a96f0b0238ff16d9c45e61e3e891a63c6386"

  option "with-test", "Run build-time check"
  option "without-python", "Build without python support"

  depends_on "libusb"
  depends_on "python3" => :recommended

  patch do
    url "https://github.com/RitwikSaikia/ncsdk/commit/e6254cdfe6b1ec2c13f3c2dc1b94485de002f62c.patch?full_index=1"
    sha256 "fc715b7c6226b16a7a25fe26aabf10144d2b8dc386355a589ef90f2f0330b469"
  end

  def install
    chmod "+x", "install-homebrew.sh"
    system "./install-homebrew.sh", prefix
    with_python = true
    with_python = false if build.without? "python"

    if with_python
      Language::Python.each_python(build) do |_, version|
        unless /3\./ =~ version
          next
        end

        python_name = "python#{version}"
        python_path = lib/"#{python_name}/site-packages"
        python_path.mkpath

        cp_r Dir["api/python/*"], python_path
      end
    end
  end

  test do
    system "true"
  end
end
