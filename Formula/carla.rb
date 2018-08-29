class Carla < Formula
  include Language::Python::Virtualenv
  
  desc "Audio plugin host supporting LADSPA, DSSI, LV2, VST2/3, AU, GIG, SF2 and SFZ"
  homepage "http://kxstudio.linuxaudio.org/Applications:Carla"
  revision 0
  url "https://github.com/falkTX/carla", :using => :git, :tag => "v1.9.9", :revision => "c03571a9ef95ac0e9564b95347f5de819aa7fb54"

  depends_on :macos => :mavericks
  depends_on "pkg-config" => :build
  depends_on "python" => :recommended
  depends_on "pyqt" => :recommended
  depends_on "libmagic" => :recommended
  depends_on "liblo" => :recommended
  depends_on "fluid-synth" => :recommended
  
  def install
    args = %W[
      PREFIX=#{prefix}
    ]
    
    # list all available carla features based on dependencies
    system "make"
    system "make", "install", *args
  end

  test do
    system bin/"carla", "--version"
  end
end
