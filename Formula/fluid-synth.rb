class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "http://www.fluidsynth.org"
  url "https://github.com/FluidSynth/fluidsynth/archive/v1.1.8.tar.gz"
  sha256 "318df5aebde8e7353c8878f5c9cb3ba8ed578c2607978b6fbfc5f1cb2ad9d799"

  bottle do
    cellar :any
    rebuild 1
    sha256 "3607f9132dbe22612d469af58f3b97aaa3225c8f93d919abf367511ceb5c79d5" => :high_sierra
    sha256 "ee86f0e263db0610a340592d725bd2c05bc5ed1bfa6eb496ae304297de261ae0" => :sierra
    sha256 "dfe31491d27c3c29ff4686900984e5884f89cd249d82b3dba4ad077f7bbe9057" => :el_capitan
    sha256 "6938c03a61b696870de92435dc0a6e6118fbb0d68adcd0d17ec8d30c2f7eee20" => :yosemite
    sha256 "5c5e00f88e45dd661c15f0e13793f9cc96f285b08200145ce8b77982350a5625" => :mavericks
    sha256 "83b972cf7aec57e78dc1c1a6b3e286d8b9bf2a2622e174bca42efa8576e36e5f" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "glib"
  depends_on "libsndfile" => :optional
  depends_on "portaudio" => :optional

  def install
    args = std_cmake_args
    args << "-Denable-framework=OFF" << "-DLIB_SUFFIX="
    args << "-Denable-portaudio=ON" if build.with? "portaudio"
    args << "-Denable-libsndfile=OFF" if build.without? "libsndfile"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/fluidsynth --version")
  end
end
