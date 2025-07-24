class CudaAT1291 < Formula
  # CUDA version variables
  CUDA_VERSION = "12.9.1".freeze
  CUDA_BUILD = "575.57.08".freeze
  GCC_VERSION = "14".freeze

  desc "NVIDIA's GPU programming toolkit"
  homepage "https://developer.nvidia.com/cuda-toolkit"

  on_arm do
    CUDA_SUFFIX = "_sbsa".freeze
    CUDA_RUN_SHA256 = "64f47ab791a76b6889702425e0755385f5fa216c5a9f061875c7deed5f08cdb6".freeze
  end
  on_intel do
    CUDA_SUFFIX = "".freeze
    CUDA_RUN_SHA256 = "0f6d806ddd87230d2adbe8a6006a9d20144fdbda9de2d6acc677daa5d036417a".freeze
  end

  url "https://developer.download.nvidia.com/compute/cuda/#{CUDA_VERSION}/local_installers/cuda_#{CUDA_VERSION}_#{CUDA_BUILD}_linux#{CUDA_SUFFIX}.run", using: :nounzip
  sha256 CUDA_RUN_SHA256
  version CUDA_VERSION

  # https://docs.nvidia.com/cuda/eula/index.html
  license :cannot_represent

  depends_on "gcc@#{GCC_VERSION}" => :build
  depends_on :linux

  def install
    cuda_suffix = Hardware::CPU.arm? ? "_sbsa" : ""
    cuda_filename = "cuda_#{CUDA_VERSION}_#{CUDA_BUILD}_linux#{cuda_suffix}.run"

    # TODO: cuda installer tries to output to /dev/tty, but fails
    ohai "Symlinking /dev/tty for CUDA installer workaround"
    system "sudo", "ln", "-sf", "#{buildpath}/cuda_run.log", "/dev/tty"

    system "./#{cuda_filename}",
           "--silent",
           "--toolkit",
           "--toolkitpath=#{prefix}",
           "--no-opengl-libs",
           "--no-man-page",
           "--no-drm"

    # print out the contents of the log file
    ohai "CUDA installation log: start"
    File.open("#{buildpath}/cuda_run.log", "r") do |file|
      file.each_line do |line|
        puts line
      end
    end
    ohai "CUDA installation log: end"
  end

  test do
    # check if the CUDA toolkit directory exists
    assert_path_exists prefix/"cuda-#{CUDA_VERSION}"

    # check if the nvcc binary is executable
    assert_predicate bin/"nvcc", :executable?

    # run the nvcc command to check if CUDA is installed correctly
    output = shell_output("#{bin}/nvcc --version")
    assert_match "Cuda compilation tools, release #{CUDA_VERSION}", output
  end
end
