class Eprover < Formula
  desc "Theorem prover for full first-order logic with equality"
  homepage "https://eprover.org/"
  url "https://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/V_2.4/E.tgz"
  sha256 "bcb76488155f2b624463c4cc50682bdbec45b30e72cfb174556670e3aff7c5f6"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc6c6e87ee95f0cfd0f0f0a838fd40bf2f9613f7e78b1a5c9f0b33bc7ca7b094" => :catalina
    sha256 "fd14ba20a1ed8799a668e6f521ddbd8c1fac8ff43ac1f14bb6c9346ee7980cf3" => :mojave
    sha256 "5db8b8088c46bde8355a4742572d63db7ccea5885b37c401e05579762271559f" => :high_sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--man-prefix=#{man1}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/eprover", "--help"
  end
end
