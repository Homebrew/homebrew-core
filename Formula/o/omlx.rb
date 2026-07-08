class Omlx < Formula
  desc "LLM inference server optimized for Apple Silicon"
  homepage "https://omlx.ai"
  url "https://github.com/jundot/omlx/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "ff06063b215cd9f9ea6d311069f13f0523164cbb9eb2d05e29ef5b48d4dcbf48"
  license "Apache-2.0"

  head "https://github.com/jundot/omlx.git", branch: "main"

  depends_on "rust" => :build
  depends_on arch: :arm64
  depends_on macos: :tahoe
  depends_on maximum_macos: :tahoe
  depends_on "python@3.14"

  def python3
    "python3.14"
  end

  def install
    system python3, "-m", "venv", libexec

    inreplace "pyproject.toml", '"transformers>=5.7.0"', '"transformers==5.9.0"'
    inreplace "pyproject.toml", '"markitdown[pdf,docx,pptx]==0.1.6"', '"markitdown==0.1.6"'

    system libexec/"bin/pip", "install",
           "--no-binary", "cohere_melody,tiktoken",
           buildpath

    site_packages = libexec/"lib/#{python3}/site-packages"
    paths_to_remove = %w[
      _sounddevice.py
      _sounddevice_data
      cv2
      lxml
      lxml-6.1.1.dist-info
      mlx_audio
      mlx_audio-0.4.4.dist-info
      opencv_python-5.0.0.93.dist-info
      pptx
      python_pptx-1.0.2.dist-info
      sounddevice.py
      sounddevice-0.5.5.dist-info
    ].map { |path| site_packages/path }
    rm_r paths_to_remove.select(&:exist?)
    rm Dir[site_packages/"*_mypyc*.so"]
    rm Dir[site_packages/"charset_normalizer/*.so"]
    rm_r site_packages/"google/_upb" if (site_packages/"google/_upb").exist?

    bin.install_symlink libexec/"bin/omlx"
  end

  service do
    run [opt_bin/"omlx", "serve"]
    keep_alive true
    working_dir var
    log_path var/"log/omlx.log"
    error_log_path var/"log/omlx.log"
    environment_variables PATH: std_service_path_env
  end

  test do
    port = free_port
    pid = spawn bin/"omlx", "serve", "--host", "127.0.0.1", "--port", port.to_s
    begin
      output = JSON.parse(shell_output("curl --silent --retry 5 --retry-connrefused http://127.0.0.1:#{port}/health"))
      assert_equal "healthy", output["status"]
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
