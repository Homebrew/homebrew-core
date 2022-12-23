class Opencoarrays < Formula
  desc "Open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "http://www.opencoarrays.org"
  url "https://github.com/sourceryinstitute/OpenCoarrays/releases/download/2.10.1/OpenCoarrays-2.10.1.tar.gz"
  sha256 "b04b8fa724e7e4e5addbab68d81d701414e713ab915bafdf1597ec5dd9590cd4"
  license "BSD-3-Clause"
  head "https://github.com/sourceryinstitute/opencoarrays.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "99be75650454833989ea1a1ed21e7b7602b093dafad27bae68ab10eefd4f3e59"
    sha256 cellar: :any,                 arm64_monterey: "8017a84d370910ce6f399e95ee94d8e4bf859293586a555fd7d4cabbe44e44cc"
    sha256 cellar: :any,                 arm64_big_sur:  "bd94cf703d0d71c39ee879b2f94560c883eb5eacf5ceb7967f2ec033d1bb1f97"
    sha256 cellar: :any,                 ventura:        "140de1807016b78a073b8c60c2adb339fd5f0755482700b1e2582d7f272c4264"
    sha256 cellar: :any,                 monterey:       "66d43cd403a60c8c521d6b20286413f8a0f74152fd0810cdfff9a7175e5944dc"
    sha256 cellar: :any,                 big_sur:        "a55e8bcd5f863aa288b94c2bc220217d8dd9514c736ad1f5d13592956fb0e4c0"
    sha256 cellar: :any,                 catalina:       "e5bf64c0dc5ca3b88fbd8aa978b74ee1ab51f4fac89de7e47e3ff9bcc72bf180"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50b392547f4fbe2878038ed716864e7923ff4bbcd047a66cc8df8ae3752854ce"
  end

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on "open-mpi"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"tally.f90").write <<~EOS
      program main
        use iso_c_binding, only : c_int
        use iso_fortran_env, only : error_unit
        implicit none
        integer(c_int) :: tally
        tally = this_image() ! this image's contribution
        call co_sum(tally)
        verify: block
          integer(c_int) :: image
          if (tally/=sum([(image,image=1,num_images())])) then
             write(error_unit,'(a,i5)') "Incorrect tally on image ",this_image()
             error stop 2
          end if
        end block verify
        ! Wait for all images to pass the test
        sync all
        if (this_image()==1) write(*,*) "Test passed"
      end program
    EOS
    system "#{bin}/caf", "tally.f90", "-o", "tally"
    system "#{bin}/cafrun", "-np", "3", "--oversubscribe", "./tally"
    assert_match Formula["open-mpi"].lib.realpath.to_s, shell_output("#{bin}/caf --show")
  end
end
