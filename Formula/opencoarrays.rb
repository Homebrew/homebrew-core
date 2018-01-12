class Opencoarrays < Formula
  desc "Open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "http://opencoarrays.org"
  url "https://github.com/sourceryinstitute/OpenCoarrays/releases/download/1.9.3/OpenCoarrays-1.9.3.tar.gz"
  sha256 "58502575c74ca079611abab1cf184b26076cb19a478113ce04a0f2cf1a607b45"
  revision 1
  head "https://github.com/sourceryinstitute/opencoarrays.git"

  bottle do
    cellar :any
    sha256 "0b3c41477130ef24703e1a5bee9ea5f2cda98ef9a7f9bda4bfa8f6ef31ed5e09" => :high_sierra
    sha256 "2942b86101f1f15f1e8a558c78806eb128434faf25051f4afdc3dd4067a9ef4d" => :sierra
    sha256 "54a04a4d7859e2fe5b3a7d7be8b14b0ae6cae9b8ee284192dd20e2cf7380c178" => :el_capitan
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
    system "#{bin}/cafrun", "-np", "3", "./tally"
  end
end
