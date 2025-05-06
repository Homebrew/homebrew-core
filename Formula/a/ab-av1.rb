class AbAv1 < Formula
  desc "AV1 re-encoding using ffmpeg, svt-av1 & vmaf"
  homepage "https://github.com/alexheretic/ab-av1"
  url "https://github.com/alexheretic/ab-av1/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "dc5f94e477b447c2a944789872dc878c61ac59a149b260d35032f3f785c85dd1"
  license "MIT"
  head "https://github.com/alexheretic/ab-av1.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c75613d8101d4c8ca36c5cf3e9e7c19bc03ae852d7b4453ad539d9706c28adaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9a55c083674f1880aecd633382df71b1f0311355947ed0df059c49bc3bec33e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "847e94448d75a54a23304210fc3c78974f8103a7341d582b92a4ed4fe46a1c87"
    sha256 cellar: :any_skip_relocation, sonoma:        "806cc8b716393aacf82fbdbf58ab4628c912a278d41ebf69ed22d9f192dd45c1"
    sha256 cellar: :any_skip_relocation, ventura:       "f5e3c1baafad271e2a01653e822d1b8d34e46c0f0c4d60367eecb0ae6645d2e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e78bed34fa05d4c60c1352e089a45337907f85f8a5cb8a84a2bff1d7cce32ab8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55433d1b895b1fd244736cb918f9c848c194124f02ffca52e1e7b13f13185ae5"
  end

  depends_on "rust" => :build
  depends_on "ffmpeg"

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"ab-av1", "print-completions", shells: [:bash, :zsh])
  end

  test do
    resource "sample-mp4" do
      url "https://download.samplelib.com/mp4/sample-5s.mp4"
      sha256 "05bd857af7f70bf51b6aac1144046973bf3325c9101a554bc27dc9607dbbd8f5"
    end

    assert_match "ab-av1 #{version}", shell_output("#{bin}/ab-av1 --version")

    resource("sample-mp4").stage testpath
    system bin/"ab-av1", "auto-encode", "-i", testpath/"sample-5s.mp4"
    assert_path_exists testpath/"sample-5s.av1.mp4"
  end
end
